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
    wire accumulation_complete = (count == 2'd3);
    wire accu_enable = valid_in | accumulation_complete;

    // Pipelined accumulation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            // Clock gating for power savings
            if (accu_enable) begin
                if (valid_in) begin
                    if (accumulation_complete) begin
                        // Final accumulation and output
                        accumulator <= data_in;
                        data_out <= accumulator + data_in;
                        count <= 2'b0;
                        valid_out <= 1'b1;
                    end else begin
                        // Intermediate accumulation
                        accumulator <= accumulator + data_in;
                        count <= count + 1'b1;
                        valid_out <= 1'b0;
                    end
                end else begin
                    valid_out <= 1'b0;
                end
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule