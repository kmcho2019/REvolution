module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_counter;
    reg in3_reg;  // Registered version of in[3]

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            done <= 1'b0;
            in3_reg <= 1'b0;
        end else begin
            // Register input to break timing path
            in3_reg <= in[3];
            
            // Default assignments
            done <= 1'b0;
            
            // State machine logic
            case (byte_counter)
                2'b00: begin  // Waiting for start
                    if (in3_reg) byte_counter <= 2'b01;
                end
                2'b01: byte_counter <= 2'b10;  // Second byte
                2'b10: begin  // Third byte
                    byte_counter <= 2'b00;
                    done <= 1'b1;
                end
                default: byte_counter <= 2'b00;
            endcase
        end
    end

endmodule