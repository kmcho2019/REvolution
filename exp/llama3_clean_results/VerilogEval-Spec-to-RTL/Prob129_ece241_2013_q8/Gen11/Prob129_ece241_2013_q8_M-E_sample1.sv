module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00; // S0
    end else begin
        case (state)
            2'b00: // S0
                if (x) state <= 2'b01; // Move to S1 on '1'
                else state <= 2'b00; // Stay in S0 on '0'
            2'b01: // S1
                if (!x) state <= 2'b10; // Move to S2 on '0'
                else state <= 2'b01; // Stay in S1 on '1'
            2'b10: // S2
                if (x) state <= 2'b00; // Reset to S0 on '1', sequence detected
                else state <= 2'b10; // Stay in S2 on '0'
            default: state <= 2'b00;
        endcase
    end
end

// Output logic
assign z = (state == 2'b10) && x;

endmodule