module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [1:0] state;
reg [31:0] counter;

initial begin
    state = 0;
    counter = 0;
    clk = 0;
end

always @(posedge state, posedge counter) begin
    case (state)
        0: begin // low state
            if (counter == (PERIOD / 2)) begin
                state = 1; // transition to high state
                counter = 0; // reset counter
                clk = 1; // set clock signal high
            end else begin
                counter = counter + 1;
            end
        end
        1: begin // high state
            if (counter == (PERIOD / 2)) begin
                state = 0; // transition to low state
                counter = 0; // reset counter
                clk = 0; // set clock signal low
            end else begin
                counter = counter + 1;
            end
        end
        default: begin
            state = 0; // default to low state
            counter = 0; // reset counter
            clk = 0; // set clock signal low
        end
    endcase
end

endmodule