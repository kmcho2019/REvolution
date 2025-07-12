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
            2'b00: begin // S0
                if (x) begin
                    state <= 2'b01; // S1
                end else begin
                    state <= 2'b00; // S0
                end
            end
            2'b01: begin // S1
                if (!x) begin
                    state <= 2'b10; // S2
                end else begin
                    state <= 2'b01; // S1
                end
            end
            2'b10: begin // S2
                if (x) begin
                    state <= 2'b01; // S1
                end else begin
                    state <= 2'b00; // S0
                end
            end
            default: state <= 2'b00; // S0
        endcase
    end
end

// Output logic
assign z = (state == 2'b10) && x;

endmodule