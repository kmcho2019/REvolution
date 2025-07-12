module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] nextState;

localparam Idle = 2'b00;
localparam Seen_1 = 2'b01;
localparam Seen_10 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= Idle;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        Idle: begin
            if (x) begin
                nextState = Seen_1;
            end else begin
                nextState = Idle;
            end
            z = 0;
        end
        Seen_1: begin
            if (x) begin
                nextState = Seen_1;
            end else begin
                nextState = Seen_10;
            end
            z = 0;
        end
        Seen_10: begin
            if (x) begin
                nextState = Seen_10;
                z = 1;
            end else if (~x) begin
                nextState = Seen_1;
                z = 0;
            end
        end
        default: begin
            nextState = Idle;
            z = 0;
        end
    endcase
end

endmodule