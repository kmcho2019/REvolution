module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;
parameter IDLE = 2'b00, GOT1 = 2'b01, GOT10 = 2'b10;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (x) begin
                    state <= GOT1;
                end else begin
                    state <= IDLE;
                end
            end
            GOT1: begin
                if (!x) begin
                    state <= GOT10;
                end else begin
                    state <= GOT1;
                end
            end
            GOT10: begin
                if (x) begin
                    state <= GOT1;
                end else begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Output logic
assign z = (state == GOT10) && x;

endmodule