module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] counter;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00; // S0
        counter <= 2'b00;
    end else begin
        case (state)
            2'b00: // S0
                if (x) begin
                    state <= 2'b01; // S1
                    counter <= 2'b01;
                end else begin
                    state <= 2'b00; // S0
                    counter <= 2'b00;
                end
            2'b01: // S1
                if (!x) begin
                    state <= 2'b10; // S2
                    counter <= 2'b10;
                end else begin
                    state <= 2'b01; // S1
                    counter <= 2'b01;
                end
            2'b10: // S2
                if (x) begin
                    state <= 2'b00; // S0
                    counter <= 2'b00;
                    z <= 1'b1;
                end else begin
                    state <= 2'b10; // S2
                    counter <= 2'b10;
                end
            default:
                state <= 2'b00; // S0
                counter <= 2'b00;
        endcase
    end
end

// Output logic
always @(*) begin
    if (state == 2'b10 && x) begin
        z <= 1'b1;
    end else begin
        z <= 1'b0;
    end
end

endmodule