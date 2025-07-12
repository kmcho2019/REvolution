module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: begin  // IDLE state
            if (x) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
            z = 1'b0;
        end
        2'b01: begin  // ONE_DETECTED state
            if (x) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b10;
            end
            z = 1'b0;
        end
        2'b10: begin  // ZERO_DETECTED state
            if (x) begin
                next_state = 2'b01;
                z = 1'b1;
            end else begin
                next_state = 2'b10;
                z = 1'b0;
            end
        end
        default: begin
            next_state = 2'b00;
            z = 1'b0;
        end
    endcase
end

endmodule