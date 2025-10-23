module TopModule(
    input           clk,
    input           reset,
    input  [7:0]    in,
    output          done
);

reg [1:0] state;
reg [1:0] nextState;
reg       doneReg;

// State encoding
parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;

// Initialize state and done
initial begin
    state = IDLE;
    doneReg = 1'b0;
end

// State transition logic
always @(*) begin
    case (state)
        IDLE: begin
            if (reset) begin
                nextState = IDLE;
            end else if (in[3] == 1'b1) begin
                nextState = BYTE1;
            end else begin
                nextState = IDLE;
            end
        end
        BYTE1: begin
            if (reset) begin
                nextState = IDLE;
            end else begin
                nextState = BYTE2;
            end
        end
        BYTE2: begin
            if (reset) begin
                nextState = IDLE;
            end else begin
                nextState = IDLE;
            end
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        IDLE: begin
            doneReg = 1'b0;
        end
        BYTE1: begin
            doneReg = 1'b0;
        end
        BYTE2: begin
            doneReg = 1'b1;
        end
        default: begin
            doneReg = 1'b0;
        end
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        doneReg <= 1'b0;
    end else begin
        state <= nextState;
        done <= doneReg;
    end
end

endmodule