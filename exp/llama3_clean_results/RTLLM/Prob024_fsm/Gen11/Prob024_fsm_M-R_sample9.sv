module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// State register
reg [2:0] state;

// Initialize state to idle (0)
initial state = 3'b000;

// Next state logic
reg [2:0] next_state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000;
    end else begin
        case (state)
            3'b000: begin
                if (IN) begin
                    next_state <= 3'b001;
                end else begin
                    next_state <= 3'b000;
                end
            end
            3'b001: begin
                if (~IN) begin
                    next_state <= 3'b010;
                end else begin
                    next_state <= 3'b000;
                end
            end
            3'b010: begin
                if (~IN) begin
                    next_state <= 3'b011;
                end else begin
                    next_state <= 3'b000;
                end
            end
            3'b011: begin
                if (IN) begin
                    next_state <= 3'b100;
                end else begin
                    next_state <= 3'b000;
                end
            end
            3'b100: begin
                if (IN) begin
                    next_state <= 3'b100;
                    MATCH <= 1'b1;
                end else begin
                    next_state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            default: begin
                next_state <= 3'b000;
            end
        endcase
        state <= next_state;
    end
end

// Output logic
assign MATCH = (state == 3'b100) && IN;

endmodule