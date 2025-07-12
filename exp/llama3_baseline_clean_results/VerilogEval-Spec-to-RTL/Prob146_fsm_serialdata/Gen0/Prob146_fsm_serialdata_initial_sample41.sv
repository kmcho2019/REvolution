module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg;
reg [2:0] state_next;

// Define states
localparam IDLE = 3'b001;
localparam START = 3'b010;
localparam DATA = 3'b011;
localparam STOP = 3'b100;
localparam DONE = 3'b101;
localparam WAIT_FOR_STOP = 3'b110;

// Define bit counter
reg [2:0] bit_counter;

// Define output reg
assign out_byte = out_byte_reg;
assign done = done_reg;

always @(*) begin
    state_next = state_reg;
    done_reg = 1'b0;

    case(state_reg)
        IDLE: begin
            if(in == 1'b0) begin
                state_next = START;
            end
        end
        START: begin
            state_next = DATA;
            bit_counter = 3'b000;
        end
        DATA: begin
            out_byte_reg = {out_byte_reg[6:0], in};
            bit_counter = bit_counter + 1'b1;
            if(bit_counter == 3'b111) begin
                state_next = STOP;
            end
        end
        STOP: begin
            if(in == 1'b1) begin
                state_next = DONE;
            end else begin
                state_next = WAIT_FOR_STOP;
            end
        end
        DONE: begin
            done_reg = 1'b1;
            state_next = IDLE;
        end
        WAIT_FOR_STOP: begin
            if(in == 1'b1) begin
                state_next = IDLE;
            end
        end
        default: state_next = IDLE;
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state_reg <= IDLE;
    end else begin
        state_reg <= state_next;
    end
end

endmodule