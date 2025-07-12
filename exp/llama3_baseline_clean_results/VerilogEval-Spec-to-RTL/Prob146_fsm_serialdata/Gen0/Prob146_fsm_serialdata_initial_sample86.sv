module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg;
reg [2:0] state_next;
reg [3:0] counter_reg;
reg [3:0] counter_next;

// Define states
localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam STOP = 3'b011;
localparam ERROR = 3'b100;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        counter_reg <= 0;
        out_byte_reg <= 0;
        done_reg <= 0;
    end else begin
        state_reg <= state_next;
        counter_reg <= counter_next;
        out_byte_reg <= out_byte_reg;
        done_reg <= done_reg;
    end
end

// Combinational logic
always @(*) begin
    case (state_reg)
        IDLE: begin
            if (in == 1'b0) begin
                state_next = START;
                counter_next = 0;
                done_reg = 0;
            end else begin
                state_next = IDLE;
                counter_next = 0;
                done_reg = 0;
            end
        end
        START: begin
            state_next = DATA;
            counter_next = 0;
            out_byte_reg[0] = in;
            done_reg = 0;
        end
        DATA: begin
            if (counter_reg == 7) begin
                state_next = STOP;
                counter_next = 0;
                out_byte_reg[7] = in;
                done_reg = 0;
            end else begin
                state_next = DATA;
                counter_next = counter_reg + 1;
                out_byte_reg[counter_reg + 1] = in;
                done_reg = 0;
            end
        end
        STOP: begin
            if (in == 1'b1) begin
                state_next = IDLE;
                counter_next = 0;
                done_reg = 1;
            end else begin
                state_next = ERROR;
                counter_next = 0;
                done_reg = 0;
            end
        end
        ERROR: begin
            if (in == 1'b1) begin
                state_next = IDLE;
                counter_next = 0;
                done_reg = 0;
            end else begin
                state_next = ERROR;
                counter_next = 0;
                done_reg = 0;
            end
        end
    endcase
end

// Output logic
assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule