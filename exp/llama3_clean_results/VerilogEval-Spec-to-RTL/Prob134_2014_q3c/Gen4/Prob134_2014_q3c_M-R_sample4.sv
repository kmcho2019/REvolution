module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

logic [2:0] currentState, nextState;

always_ff @(posedge clk) begin
    currentState <= nextState;
end

always_comb begin
    case (currentState)
        3'b000: begin
            if (!x) begin
                nextState = 3'b000;
            end else begin
                nextState = 3'b001;
            end
        end
        3'b001: begin
            if (!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b100;
            end
        end
        3'b010: begin
            if (!x) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b001;
            end
        end
        3'b011: begin
            if (!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b010;
            end
        end
        3'b100: begin
            if (!x) begin
                nextState = 3'b011;
            end else begin
                nextState = 3'b100;
            end
        end
        default: begin
            nextState = 3'b000;
        end
    endcase
end

assign Y0 = nextState[0];
assign z = (currentState == 3'b011 || currentState == 3'b100);

initial begin
    currentState = 3'b000;
end