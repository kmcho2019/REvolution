module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state;  // Use 1 bit to represent two states
parameter A = 1'b0;
parameter B = 1'b1;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= B;  // Asynchronously reset into state B
    end else begin
        case(state)
            A: begin
                if(in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            B: begin
                if(in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
        endcase
    end
end

// Since this is a Moore machine, out is determined solely by the state
assign out = state;

endmodule