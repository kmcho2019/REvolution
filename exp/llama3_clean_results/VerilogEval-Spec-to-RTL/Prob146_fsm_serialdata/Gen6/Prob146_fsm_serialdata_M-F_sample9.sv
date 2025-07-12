module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output reg done
);

// Define the states of the FSM using binary encoding
reg [1:0] state;
parameter Idle = 2'b00, Receive = 2'b01, WaitStop = 2'b10;

// Define the register to store the received data byte
reg [7:0] data_byte;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        data_byte <= 8'b0;
        done <= 0;
    end else begin
        case (state)
            Idle: begin
                if (in == 0) begin
                    // Start bit received, transition to Receive state
                    state <= Receive;
                    data_byte <= 8'b0;
                end else begin
                    // Still in Idle state
                    state <= Idle;
                end
            end
            Receive: begin
                // Shift in the current bit into the data byte
                data_byte <= {data_byte[6:0], in};
                if (data_byte[7] == 1'b1) begin
                    // 8 data bits received, transition to WaitStop state
                    state <= WaitStop;
                end else begin
                    // Still in Receive state
                    state <= Receive;
                end
            end
            WaitStop: begin
                if (in == 1) begin
                    // Stop bit received, output received data byte
                    done <= 1;
                    state <= Idle;
                end else begin
                    // Wait for stop bit
                    state <= WaitStop;
                end
            end
            default: state <= Idle;
        endcase
    end
end

// Combinational logic
assign out_byte = data_byte;

// Reset done signal on next clock cycle
always_ff @(posedge clk) begin
    if (state != WaitStop || in != 1) begin
        done <= 0;
    end
end

endmodule