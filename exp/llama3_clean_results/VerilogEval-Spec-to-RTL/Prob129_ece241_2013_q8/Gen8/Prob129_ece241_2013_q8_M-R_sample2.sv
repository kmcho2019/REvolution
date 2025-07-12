module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

reg [1:0] state; // 2-bit state variable

// Define states
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

// Asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        case (state)
            S0: if (x == 1'b1) state <= S1;
                 else state <= S0;
            S1: if (x == 1'b0) state <= S2;
                 else state <= S1;
            S2: if (x == 1'b1) begin
                    state <= S0;
                    z <= 1'b1;
                end
                 else state <= S0;
            default: state <= S0;
        endcase
    end
end

// Output logic
always @(posedge clk) begin
    if (state == S0 || state == S1 || state == S2) begin
        if (state != S2 || x != 1'b1) z <= 1'b0;
    end
end

endmodule