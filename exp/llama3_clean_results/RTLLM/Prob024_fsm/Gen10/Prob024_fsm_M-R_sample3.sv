module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // 5-state machine
reg [2:0] next_state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        3'b000: begin // Initial state
            if (IN) next_state = 3'b001;
            else next_state = 3'b000;
        end
        3'b001: begin // First '1' detected
            if (!IN) next_state = 3'b010;
            else next_state = 3'b001;
        end
        3'b010: begin // First '0' detected
            if (!IN) next_state = 3'b011;
            else next_state = 3'b001;
        end
        3'b011: begin // Second '0' detected
            if (IN) next_state = 3'b100;
            else next_state = 3'b011;
        end
        3'b100: begin // First '1' detected after two '0's
            if (IN) begin
                next_state = 3'b101;
            end else begin
                next_state = 3'b000;
            end
        end
        3'b101: begin // Second '1' detected after two '0's
            if (IN) begin
                next_state = 3'b000;
            end else begin
                next_state = 3'b000;
            end
        end
        default: begin
            next_state = 3'b000;
        end
    endcase
end

assign MATCH = (state == 3'b100 && IN);

endmodule