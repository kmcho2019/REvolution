module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [2:0] nextState;
reg [7:0] dataReg;
reg [3:0] bitCounter;

always @(*) begin
    case(state)
        3'b000: begin // IDLE
            if(in == 1'b0) begin
                nextState = 3'b001; // START
            end else begin
                nextState = 3'b000; // IDLE
            end
        end
        3'b001: begin // START
            nextState = 3'b010; // DATA
        end
        3'b010: begin // DATA
            if(bitCounter == 4'd8) begin
                nextState = 3'b011; // STOP
            end else begin
                nextState = 3'b010; // DATA
            end
        end
        3'b011: begin // STOP
            if(in == 1'b1) begin
                nextState = 3'b100; // DONE
            end else begin
                nextState = 3'b011; // STOP
            end
        end
        3'b100: begin // DONE
            nextState = 3'b000; // IDLE
        end
        default: begin
            nextState = 3'b000; // IDLE
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 3'b000;
        dataReg <= 8'b0;
        bitCounter <= 4'b0;
        out_byte <= 8'b0;
        done <= 1'b0;
    end else begin
        state <= nextState;
        if(nextState == 3'b010) begin // DATA
            dataReg <= {dataReg[6:0], in};
            bitCounter <= bitCounter + 1'b1;
        end else if(nextState == 3'b011) begin // STOP
            bitCounter <= 4'b0;
        end else if(nextState == 3'b100) begin // DONE
            out_byte <= dataReg;
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule