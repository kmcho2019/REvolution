module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states of the FSM
localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam STOP = 3'b011;
localparam WAIT_FOR_STOP = 3'b100;

// Register to store the current state
reg [2:0] state;

// Register to store the received byte
reg [7:0] byte;

// Counter for the data bits
reg [2:0] bit_count;

// Output registers
reg [7:0] out_byte_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
        byte <= 8'b0;
        bit_count <= 3'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    state <= START;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                state <= DATA;
                byte[0] <= in;
                bit_count <= 1;
            end
            DATA: begin
                if (bit_count == 3'd7) begin
                    state <= STOP;
                    byte[7] <= in;
                end else begin
                    state <= DATA;
                    byte[bit_count + 1] <= in;
                    bit_count <= bit_count + 1;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    state <= IDLE;
                    out_byte_reg <= byte;
                    done_reg <= 1'b1;
                end else begin
                    state <= WAIT_FOR_STOP;
                end
            end
            WAIT_FOR_STOP: begin
                if (in == 1'b1) begin
                    state <= IDLE;
                end else begin
                    state <= WAIT_FOR_STOP;
                end
            end
            default: state <= IDLE;
        endcase
        if (state!= STOP) begin
            done_reg <= 1'b0;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule