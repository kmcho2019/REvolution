module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // 2-bit state register
parameter IDLE = 2'b00, SEQ_10 = 2'b01, SEQ_101 = 2'b10;

// Asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (x) begin
                    state <= SEQ_10;
                end
            end
            SEQ_10: begin
                if (x) begin
                    state <= SEQ_101;
                end else begin
                    state <= IDLE;
                end
            end
            SEQ_101: begin
                if (x) begin
                    state <= SEQ_101;
                end else begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Output logic
assign z = (state == SEQ_101);

endmodule