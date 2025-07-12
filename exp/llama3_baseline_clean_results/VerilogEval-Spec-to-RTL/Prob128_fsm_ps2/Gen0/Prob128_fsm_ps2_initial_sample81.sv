module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

// Define the state variable
reg [1:0] state;
reg [1:0] nextState;

// Define the state encoding
localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam BYTE3 = 2'b11;

// FSM logic
always @(*) begin
    case (state)
        IDLE: begin
            if (in[3]) begin
                nextState = BYTE1;
            end else begin
                nextState = IDLE;
            end
        end
        BYTE1: begin
            nextState = BYTE2;
        end
        BYTE2: begin
            nextState = BYTE3;
        end
        BYTE3: begin
            nextState = IDLE;
        end
        default: nextState = IDLE;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= nextState;
    end
end

// Output logic
assign done = (state == BYTE2) && (nextState == BYTE3);

endmodule