module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    reg [1:0] byte_counter;
    reg [23:0] message_reg;
    reg valid_start;

    // Sequential logic for state and data storage
    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            valid_start <= 1'b0;
            message_reg <= 24'bx;
        end else begin
            if (!valid_start) begin
                // Waiting for start byte
                if (in[3]) begin
                    valid_start <= 1'b1;
                    byte_counter <= 2'b01;
                    message_reg[23:16] <= in;
                end
            end else begin
                // Collecting message bytes
                case (byte_counter)
                    2'b01: begin
                        message_reg[15:8] <= in;
                        byte_counter <= 2'b10;
                    end
                    2'b10: begin
                        message_reg[7:0] <= in;
                        byte_counter <= 2'b00;
                        valid_start <= 1'b0;
                    end
                    default: byte_counter <= 2'b00;
                endcase
            end
        end
    end

    // Combinational output logic
    assign done = (byte_counter == 2'b00) && valid_start;
    assign out_bytes = done ? message_reg : 24'bx;

endmodule