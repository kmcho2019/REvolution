module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] byte;
reg [2:0] state;
reg [2:0] next_state;
reg [7:0] counter;
reg [7:0] out_reg;
reg done_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000; // IDLE state
        counter <= 8'b0;
        byte <= 8'b0;
        out_reg <= 8'b0;
        done_reg <= 1'b0;
    end else begin
        case(state)
            3'b000: // IDLE state
                if (~in) begin
                    state <= 3'b001; // START state
                    counter <= 8'b1;
                    byte[0] <= in;
                end else begin
                    state <= 3'b000;
                end
            3'b001: // START state
                if (counter < 8) begin
                    counter <= counter + 1'b1;
                    byte[counter] <= in;
                    state <= 3'b001;
                end else begin
                    state <= 3'b010; // STOP state
                end
            3'b010: // STOP state
                if (in) begin
                    out_reg <= byte;
                    done_reg <= 1'b1;
                    state <= 3'b000; // IDLE state
                end else begin
                    state <= 3'b010;
                end
            default:
                state <= 3'b000; // IDLE state
        endcase
    end
end

always @(*) begin
    out_byte = out_reg;
    done = done_reg;
end

endmodule