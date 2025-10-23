module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define the states of the FSM
reg [2:0] state, next_state;

// Initialize the state
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        state <= next_state;
        case (state)
            3'b000: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            3'b001: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            3'b010: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (s[1] == 1'b0 && s[0] == 1'b1)? 1'b1 : 1'b0;
            end
            3'b011: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (s[2] == 1'b0 && s[1] == 1'b1)? 1'b1 : 1'b0;
            end
            3'b100: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

// Determine the next state
always @(*) begin
    case (state)
        3'b000: next_state = (s == 3'b000)? 3'b000 : 3'b001;
        3'b001: next_state = (s[0] == 1'b1)? 3'b010 : 3'b001;
        3'b010: next_state = (s[1] == 1'b1)? 3'b011 : (s[0] == 1'b0)? 3'b001 : 3'b010;
        3'b011: next_state = (s[2] == 1'b1)? 3'b100 : (s[1] == 1'b0)? 3'b010 : 3'b011;
        3'b100: next_state = 3'b100;
        default: next_state = 3'b000;
    endcase
end

endmodule