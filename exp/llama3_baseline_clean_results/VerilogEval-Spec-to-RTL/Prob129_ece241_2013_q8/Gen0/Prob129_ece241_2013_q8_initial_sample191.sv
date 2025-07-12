module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state, next_state;
parameter Idle = 2'b00, Received1 = 2'b01, Received10 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= Idle;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        Idle: begin
            if (x) begin
                next_state = Received1;
            end else begin
                next_state = Idle;
            end
        end
        Received1: begin
            if (~x) begin
                next_state = Received10;
            end else begin
                next_state = Received1;
            end
        end
        Received10: begin
            if (x) begin
                next_state = Received1;
            end else begin
                next_state = Received10;
            end
        end
    endcase
end

assign z = (state == Received10 && x);

endmodule