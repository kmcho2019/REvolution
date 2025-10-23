module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
localparam [2:0] IDLE = 3'b000;
localparam [2:0] S1 = 3'b001;
localparam [2:0] S2 = 3'b010;
localparam [2:0] S3 = 3'b011;
localparam [2:0] S4 = 3'b100;
localparam [2:0] S5 = 3'b101;

reg [2:0] current_state;
reg [2:0] next_state;

always @(*) begin
    case (current_state)
        IDLE: begin
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if (IN == 1'b0)
                next_state = S2;
            else
                next_state = IDLE;
        end
        S2: begin
            if (IN == 1'b0)
                next_state = S3;
            else
                next_state = IDLE;
        end
        S3: begin
            if (IN == 1'b1)
                next_state = S4;
            else
                next_state = IDLE;
        end
        S4: begin
            if (IN == 1'b1)
                next_state = S5;
            else
                next_state = IDLE;
        end
        S5: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == S5)
            MATCH <= 1'b1;
        else
            MATCH <= 1'b0;
    end
end

endmodule