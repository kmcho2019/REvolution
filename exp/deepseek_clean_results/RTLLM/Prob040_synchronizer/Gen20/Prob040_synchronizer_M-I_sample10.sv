module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock A domain registers
    reg [3:0] data_reg;
    reg [3:0] prev_data_in;
    reg req_a;
    wire data_changed;
    
    // Clock B domain registers
    reg req_sync1, req_sync2;
    
    // Detect data changes to minimize updates
    assign data_changed = (data_in != prev_data_in);
    
    // Clock A domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            prev_data_in <= 4'b0;
            req_a <= 1'b0;
        end else begin
            prev_data_in <= data_in;
            if (data_en && data_changed) begin
                data_reg <= data_in;
            end
            req_a <= data_en;
        end
    end

    // Clock B domain synchronization with conditional update
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            req_sync1 <= 1'b0;
            req_sync2 <= 1'b0;
        end else begin
            req_sync1 <= req_a;
            if (req_sync1 != req_sync2) begin  // Only update when needed
                req_sync2 <= req_sync1;
            end
        end
    end

    // Output register using synchronized enable directly
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (req_sync2) begin
            dataout <= data_reg;
        end
    end

endmodule