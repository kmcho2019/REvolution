module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [2:0] nextState;
reg [7:0] byte;
reg [3:0] count;
reg [3:0] nextCount;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b001; // IDLE state
        byte <= 8'b0;
        count <= 4'b0;
        done <= 1'b0;
    end else begin
        state <= nextState;
        byte <= out_byte;
        count <= nextCount;
        done <= 1'b0;
    end
end

always @(*) begin
    case (state)
        3'b001: begin // IDLE state
            if (in == 1'b0) begin // Start bit detected
                nextState = 3'b010; // Transition to DATA state
                nextCount = 4'b1;
                out_byte = 8'b0;
            end else begin
                nextState = 3'b001; // Stay in IDLE state
                nextCount = 4'b0;
            end
        end
        3'b010: begin // DATA state
            if (count == 4'b1000) begin // 8 data bits received
                nextState = 3'b011; // Transition to STOP state
                nextCount = 4'b0;
            end else begin
                nextState = 3'b010; // Stay in DATA state
                nextCount = count + 1'b1;
                out_byte = {out_byte[6:0], in};
            end
        end
        3'b011: begin // STOP state
            if (in == 1'b1) begin // Stop bit correct
                nextState = 3'b001; // Transition to IDLE state
                nextCount = 4'b0;
                done = 1'b1;
            end else begin
                nextState = 3'b011; // Stay in STOP state
                nextCount = 4'b0;
            end
        end
        default: begin
            nextState = 3'b001; // Default to IDLE state
            nextCount = 4'b0;
        end
    endcase
end

endmodule