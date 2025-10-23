module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] byte;
reg [2:0] state;
reg [3:0] counter;
reg done_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 3'b000; // IDLE
        byte <= 8'b0;
        counter <= 4'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE
                if (~in) begin // Start bit detected
                    state <= 3'b001; // START
                end
            end
            3'b001: begin // START
                state <= 3'b010; // DATA
            end
            3'b010: begin // DATA
                byte[3'd0] <= in; // Store the received bit in the least significant bit of the byte
                if (counter == 4'd7) begin
                    state <= 3'b011; // STOP
                end else begin
                    byte <= {byte[6:0], in}; // Shift the byte and store the received bit
                    counter <= counter + 1'b1;
                end
            end
            3'b011: begin // STOP
                if (in) begin // Stop bit detected
                    state <= 3'b100; // DONE
                end
            end
            3'b100: begin // DONE
                done_reg <= 1'b1;
                state <= 3'b000; // IDLE
            end
            default: state <= 3'b000; // IDLE
        endcase
        if (state == 3'b100) begin // DONE
            out_byte <= byte;
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule