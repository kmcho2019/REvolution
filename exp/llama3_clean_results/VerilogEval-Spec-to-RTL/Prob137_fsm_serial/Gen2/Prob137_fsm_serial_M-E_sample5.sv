module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Define states
enum logic [1:0] {IDLE, RECEIVING, STOP_WAIT, DONE} state, nextState;

// Shift register for receiving data
reg [9:0] shiftReg;

always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
        done <= 1'b0;
        shiftReg <= 10'b0;
    end else begin
        state <= nextState;
        case(state)
            IDLE: begin
                if(in == 1'b0) begin
                    shiftReg <= {9'b0, in};
                    nextState <= RECEIVING;
                end else begin
                    nextState <= IDLE;
                end
            end
            RECEIVING: begin
                shiftReg <= {shiftReg[8:0], in};
                if(&shiftReg[9:1]) begin // Check if 9 bits have been received
                    nextState <= STOP_WAIT;
                end else begin
                    nextState <= RECEIVING;
                end
            end
            STOP_WAIT: begin
                if(in == 1'b1) begin
                    if(shiftReg[0] == 1'b0 && shiftReg[9] == 1'b1) begin // Check start and stop bits
                        done <= 1'b1;
                    end else begin
                        done <= 1'b0;
                    end
                    nextState <= DONE;
                end else begin
                    nextState <= STOP_WAIT;
                end
            end
            DONE: begin
                done <= 1'b0;
                nextState <= IDLE;
            end
        endcase
    end
end

endmodule