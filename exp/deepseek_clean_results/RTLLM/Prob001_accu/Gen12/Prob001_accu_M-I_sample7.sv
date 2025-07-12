module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;
    reg [9:0] accumulator;
    reg [7:0] data_pipeline;
    reg valid_pipeline;
    
    // Clock gating enable
    wire accum_en = valid_in | (count != 0);
    
    // Counter and accumulation logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            accumulator <= 10'b0;
            data_pipeline <= 8'b0;
            valid_pipeline <= 1'b0;
        end else if (accum_en) begin
            if (valid_in) begin
                // First pipeline stage: store input and increment count
                data_pipeline <= data_in;
                valid_pipeline <= 1'b1;
                count <= count + 1;
                
                // Second pipeline stage: accumulation
                if (valid_pipeline) begin
                    if (count == 2'b11) begin
                        accumulator <= {2'b0, data_pipeline} + data_in;
                    end else begin
                        accumulator <= accumulator + data_pipeline;
                    end
                end
            end else begin
                valid_pipeline <= 1'b0;
            end
        end
    end
    
    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else begin
            valid_out <= (count == 2'b11) & valid_in;
            if ((count == 2'b11) & valid_in) begin
                data_out <= accumulator + data_in;
            end
        end
    end

endmodule