module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [1:0] state; // IDLE (0), COUNTING (1)
assign tc = (state == 1 && counter == 0) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    case(state)
        2'b00: // IDLE
            begin
                if(load) begin
                    counter <= data;
                    state <= 2'b01; // Transition to COUNTING
                end
            end
        2'b01: // COUNTING
            begin
                if(load) begin
                    counter <= data;
                end else if(counter != 0) begin
                    counter <= counter - 1;
                end
            end
        default: state <= 2'b00; // Reset to IDLE
    endcase
end

initial begin
    state <= 2'b00; // Initialize to IDLE
end

endmodule