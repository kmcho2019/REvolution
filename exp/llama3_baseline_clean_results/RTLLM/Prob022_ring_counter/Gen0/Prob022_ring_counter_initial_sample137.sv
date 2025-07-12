module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;
reg [2:0] counter;  // counter to keep track of the current state

initial begin
    state = 8'b0000_0001;  // initialize the state to the LSB
    counter = 3'b000;  // initialize the counter to 0
end

always @ (posedge clk or posedge reset) begin
    if (reset) begin  // if reset is high, reset the state and counter
        state <= 8'b0000_0001;
        counter <= 3'b000;
    end else begin  // otherwise, update the state based on the counter
        counter <= counter + 1;  // increment the counter
        if (counter == 3'b111) begin  // if counter is 7, reset it to 0
            counter <= 3'b000;
        end
        case (counter)  // use the counter to determine the current state
            3'b000: state <= 8'b0000_0001;
            3'b001: state <= 8'b0000_0010;
            3'b010: state <= 8'b0000_0100;
            3'b011: state <= 8'b0000_1000;
            3'b100: state <= 8'b0001_0000;
            3'b101: state <= 8'b0010_0000;
            3'b110: state <= 8'b0100_0000;
            3'b111: state <= 8'b1000_0000;
        endcase
    end
end

assign out = state;  // assign the state to the output

endmodule