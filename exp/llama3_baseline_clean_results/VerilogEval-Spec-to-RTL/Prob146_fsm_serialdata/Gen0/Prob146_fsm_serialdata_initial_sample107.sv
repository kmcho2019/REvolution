module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

// Define the states
enum logic [2:0] { Idle, Start, Data, StopWait, Stop } state, nextState;

// Data byte register
logic [7:0] data;

// Bit counter
logic [2:0] bitCount;

always_comb begin
    // Default values
    nextState = state;
    done = 1'b0;

    case(state)
        Idle: begin
            if (in == 1'b0) begin
                nextState = Start;
            end
        end

        Start: begin
            nextState = Data;
            bitCount = 3'b000; // Initialize bit counter
        end

        Data: begin
            data[bitCount] = in; // Store the data bit
            bitCount = bitCount + 1'b1;

            if (bitCount == 3'b111) begin // All 8 data bits received
                nextState = StopWait;
            end
        end

        StopWait: begin
            if (in == 1'b1) begin // Stop bit detected
                nextState = Stop;
            end
        end

        Stop: begin
            nextState = Idle; // Reset to idle state
            done = 1'b1; // Assert done signal
        end

        default: begin
            nextState = Idle;
        end
    endcase
end

always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= Idle;
        data <= 8'b0;
        bitCount <= 3'b000;
        out_byte <= 8'b0;
    end else begin
        state <= nextState;
        if (state == Stop) begin
            out_byte <= {data[7:1], in}; // Output the received data byte
        end
    end
end

endmodule