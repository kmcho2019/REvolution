module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
parameter B = 0, A = 1;

reg [0:0] state, next_state;

// State register
always @(posedge clk) begin
    if(reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case(state)
        B: begin
            if(!in) begin
                next_state <= A;
            end else begin
                next_state <= B;
            end
        end
        A: begin
            if(!in) begin
                next_state <= B;
            end else begin
                next_state <= A;
            end
        end
        default: next_state <= B;
    endcase
end

// Output logic
assign out = (state == B) ? 1'b1 : 1'b0;

endmodule