module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// State declaration
enum logic [0:0] {IDLE, RECEIVING} state;

// Shift register to store the incoming bytes
reg [23:0] shift_register;

// Counter to keep track of the number of bytes received
reg [1:0] byte_counter;

// Sequential logic to update the state and internal registers
always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= IDLE;
        shift_register <= 24'd0;
        byte_counter <= 2'd0;
        done <= 1'b0;
        out_bytes <= 24'd0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    state <= RECEIVING;
                    shift_register <= {in, 16'd0};
                    byte_counter <= 1'd1;
                end
            end
            RECEIVING: begin
                if (byte_counter == 2'd2) begin
                    state <= IDLE;
                    shift_register <= {shift_register[15:0], in};
                    byte_counter <= 2'd0;
                    done <= 1'b1;
                    out_bytes <= shift_register;
                end else begin
                    shift_register <= {shift_register[15:0], in};
                    byte_counter <= byte_counter + 1'd1;
                end
            end
            default: state <= IDLE;
        endcase
        if (state!= RECEIVING || byte_counter!= 2'd2) begin
            done <= 1'b0;
        end
    end
end

endmodule