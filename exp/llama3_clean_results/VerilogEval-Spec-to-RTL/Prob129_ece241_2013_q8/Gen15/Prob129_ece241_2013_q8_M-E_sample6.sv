module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // 2-bit state register for 3 states (S0, S1, S2)

// State encoding
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        case (state)
            S0: begin
                if (x) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
            S1: begin
                if (!x) begin
                    state <= S2;
                end else begin
                    state <= S1;
                end
            end
            S2: begin
                if (x) begin
                    state <= S1; // Transition back to S1 for overlapping sequence recognition
                end else begin
                    state <= S0;
                end
            end
            default: state <= S0;
        endcase
    end
end

// Output logic
assign z = (state == S2) && x;

endmodule