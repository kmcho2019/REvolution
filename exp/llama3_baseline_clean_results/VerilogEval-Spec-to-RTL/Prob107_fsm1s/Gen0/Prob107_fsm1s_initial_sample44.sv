module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // Current state
parameter A = 1'b0, B = 1'b1; // State encodings

always_ff @(posedge clk) begin
    if(reset) begin // Active-high synchronous reset
        state <= B;
    end else begin
        case(state)
            A: begin
                if(!in)
                    state <= B;
                else
                    state <= A;
            end
            B: begin
                if(!in)
                    state <= A;
                else
                    state <= B;
            end
        endcase
    end
end

assign out = (state == B) ? 1'b1 : 1'b0; // Output based on current state

endmodule