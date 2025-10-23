module synchronizer #(
    parameter WIDTH = 4
) (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [WIDTH-1:0] data_in,
    input wire data_en,
    output reg [WIDTH-1:0] dataout
);

    // Clock domain A registers
    reg [WIDTH-1:0] data_reg;
    reg data_en_reg;
    reg data_en_stable;
    reg [WIDTH-1:0] prev_data_in;
    
    // Shared reset for clk_a domain
    wire a_reset = !arstn;
    
    always @(posedge clk_a or posedge a_reset) begin
        if (a_reset) begin
            data_reg <= {WIDTH{1'b0}};
            data_en_reg <= 1'b0;
            data_en_stable <= 1'b0;
            prev_data_in <= {WIDTH{1'b0}};
        end else begin
            // Only update if data changed or enable changed
            if (data_en && (prev_data_in != data_in || !data_en_reg)) begin
                data_reg <= data_in;
                prev_data_in <= data_in;
            end
            data_en_reg <= data_en;
            // Detect stable enable
            data_en_stable <= (data_en_reg == data_en);
        end
    end

    // Clock domain B registers
    reg [1:0] en_sync;
    reg [WIDTH-1:0] data_pipe;
    
    // Shared reset for clk_b domain
    wire b_reset = !brstn;
    
    always @(posedge clk_b or posedge b_reset) begin
        if (b_reset) begin
            en_sync <= 2'b00;
            data_pipe <= {WIDTH{1'b0}};
            dataout <= {WIDTH{1'b0}};
        end else begin
            // Only synchronize enable when it changes
            if (!data_en_stable) begin
                en_sync <= {en_sync[0], data_en_reg};
            end
            
            // Pipeline stage for better timing
            if (en_sync[0]) begin
                data_pipe <= data_reg;
            end
            
            // Final output stage
            if (en_sync[1]) begin
                dataout <= data_pipe;
            end
        end
    end

endmodule