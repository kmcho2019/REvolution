module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// State declaration
enum logic [0:0] {IDLE, RECEIVING} state;

// 3-byte array to store the incoming bytes
reg [7:0] bytes [2:0];

// Counter to keep track of the number of bytes received
reg [1:0] byte_counter;

// Sequential logic to update the state and internal registers
always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= IDLE;
        bytes[0] <= 8'd0;
        bytes[1] <= 8'd0;
        bytes[2] <= 8'd0;
        byte_counter <= 2'd0;
        done <= 1'b0;
        out_bytes <= 24'd0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    state <= RECEIVING;
                    bytes[0] <= in;
                    byte_counter <= 1'd1;
                end
            end
            RECEIVING: begin
                if (byte_counter == 2'd2) begin
                    state <= IDLE;
                    bytes[2] <= in;
                    byte_counter <= 2'd0;
                    done <= 1'b1;
                    out_bytes <= {bytes[0], bytes[1], bytes[2]};
                end else begin
                    if (byte_counter == 1'd1) begin
                        bytes[1] <= in;
                        byte_counter <= byte_counter + 1'd1;
                    end else if (byte_counter == 1'd2) begin
                        bytes[2] <= in;
                        byte_counter <= byte_counter + 1'd1;
                    end
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