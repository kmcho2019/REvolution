module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

// Define the states
parameter RESET = 7'b0000000;
parameter ZERO   = 7'b0000001;
parameter ONE    = 7'b0000010;
parameter ONES1  = 7'b0000100;
parameter ONES2  = 7'b0001000;
parameter ONES3  = 7'b0010000;
parameter ONES4  = 7'b0100000;
parameter ONES5  = 7'b1000000;
parameter FLAG   = 7'b0000011;
parameter ERROR  = 7'b1000001;

reg [6:0] state;
reg [6:0] next_state;

always @(*) begin
    case(state)
        RESET: begin
            if(reset) next_state = RESET;
            else next_state = in ? ONE : ZERO;
        end
        ZERO: begin
            next_state = in ? ONE : ZERO;
        end
        ONE: begin
            next_state = in ? ONES1 : ZERO;
        end
        ONES1: begin
            next_state = in ? ONES2 : ZERO;
        end
        ONES2: begin
            next_state = in ? ONES3 : ZERO;
        end
        ONES3: begin
            next_state = in ? ONES4 : ZERO;
        end
        ONES4: begin
            next_state = in ? ONES5 : ZERO;
        end
        ONES5: begin
            next_state = in ? ERROR : ZERO;
            disc = in ? 1'b1 : 1'b0;
        end
        ERROR: begin
            next_state = in ? ERROR : ZERO;
            err = 1'b1;
        end
        FLAG: begin
            next_state = in ? ONE : ZERO;
            flag = 1'b1;
        end
        default: next_state = RESET;
    endcase
end

always @(posedge clk) begin
    if(reset) state <= RESET;
    else state <= next_state;
end

assign flag = (state == FLAG);
assign disc = (state == ONES5);
assign err = (state == ERROR);

endmodule