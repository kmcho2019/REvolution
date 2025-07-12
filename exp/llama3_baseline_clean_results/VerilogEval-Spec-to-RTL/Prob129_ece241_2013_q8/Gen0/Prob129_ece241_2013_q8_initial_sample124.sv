module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state, next_state;

localparam IDLE = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        IDLE: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (!x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
    endcase
end

assign z = (state == S2 && x);

endmodule