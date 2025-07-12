module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output [9:0] data_out
);

    reg [1:0] count;        // Gray coded counter
    reg [9:0] accumulator;  // Accumulator (now directly outputs)
    reg [7:0] stage1_reg;   // Pipeline register for first stage

    // Gray code terminal count detection (count == 3)
    wire terminal_count = count[1] & ~count[0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            accumulator <= 10'b0;
            stage1_reg <= 8'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0;
            
            if (valid_in) begin
                // Gray counter increment
                case (count)
                    2'b00: count <= 2'b01;
                    2'b01: count <= 2'b11;
                    2'b11: count <= 2'b10;
                    2'b10: begin 
                        count <= 2'b00;
                        valid_out <= 1'b1;
                    end
                endcase

                // Pipelined accumulation
                if (~count[1]) begin
                    // First stage: sum of inputs 0 and 1
                    stage1_reg <= data_in;
                    if (count[0]) 
                        accumulator[8:0] <= accumulator[7:0] + stage1_reg;
                end
                else begin
                    // Second stage: sum of inputs 2 and 3
                    if (count[0]) 
                        accumulator <= accumulator + {2'b0, data_in} + {2'b0, stage1_reg};
                end
            end
        end
    end

    assign data_out = accumulator;

endmodule