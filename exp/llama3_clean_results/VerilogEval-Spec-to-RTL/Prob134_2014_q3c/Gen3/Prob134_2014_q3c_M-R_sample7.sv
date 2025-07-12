module TopModule(
    input  clk,
    input  rst_n,  // Active low reset
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

enum logic [2:0] {S000, S001, S010, S011, S100, S011_2, S100_2} currentState, nextState;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        currentState <= S000;
    end else begin
        currentState <= nextState;
    end
end

always_comb begin
    case (currentState)
        S000: begin
            if (!x) begin
                nextState = S000;
            end else begin
                nextState = S001;
            end
        end
        S001: begin
            if (!x) begin
                nextState = S001;
            end else begin
                nextState = S100;
            end
        end
        S010: begin
            if (!x) begin
                nextState = S010;
            end else begin
                nextState = S001;
            end
        end
        S011: begin
            if (!x) begin
                nextState = S001;
            end else begin
                nextState = S010;
            end
        end
        S100: begin
            if (!x) begin
                nextState = S011_2;
            end else begin
                nextState = S100_2;
            end
        end
        S011_2: begin
            nextState = S011;
        end
        S100_2: begin
            nextState = S100;
        end
        default: begin
            nextState = S000;
        end
    endcase
end

assign Y0 = currentState[0];
assign z = (currentState == S011 || currentState == S100);