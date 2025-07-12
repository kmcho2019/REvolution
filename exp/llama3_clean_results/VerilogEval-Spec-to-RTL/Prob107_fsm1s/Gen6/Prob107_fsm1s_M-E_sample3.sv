module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

reg state; // Using a single bit for two states
parameter B = 1'b1;
parameter A = 1'b0;

// Output logic
assign out = state;

// State register with simplified logic
always @(posedge clk) begin
    if(reset) begin
        state <= B;
    end else begin
        case ({state, in})
            2'b00, 2'b11: state <= in ? B : A;
            2'b01, 2'b10: state <= in ? A : B;
        endcase
    end
end

endmodule