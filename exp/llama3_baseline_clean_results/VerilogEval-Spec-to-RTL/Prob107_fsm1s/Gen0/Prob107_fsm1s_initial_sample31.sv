module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
enum logic [1:0] {B, A} state, next_state;

// Output logic
always_comb begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
    endcase
end

// State machine logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= B;
    end else begin
        case(state)
            B: begin
                if(in == 1'b0) state <= A;
                else state <= B;
            end
            A: begin
                if(in == 1'b0) state <= B;
                else state <= A;
            end
        endcase
    end
end

endmodule