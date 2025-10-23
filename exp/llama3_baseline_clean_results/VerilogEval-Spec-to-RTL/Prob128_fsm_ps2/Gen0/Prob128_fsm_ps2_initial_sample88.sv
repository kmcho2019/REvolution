module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] nextState;

// Define states
localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam DONE = 2'b11;

always @(*) begin
    case (state)
        IDLE: 
            if (in[3]) 
                nextState = BYTE1;
            else 
                nextState = IDLE;
        BYTE1: 
            nextState = BYTE2;
        BYTE2: 
            nextState = DONE;
        DONE: 
            nextState = IDLE;
        default: 
            nextState = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 0;
    end else begin
        state <= nextState;
        if (state == DONE) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

endmodule