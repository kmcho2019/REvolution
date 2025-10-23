module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;
reg [1:0] state;

always @(posedge clk) begin
    case (state)
        2'b00: begin // LOAD state
            if (load) begin
                count <= data;
            end else begin
                state <= 2'b01; // transition to COUNT state
            end
        end
        2'b01: begin // COUNT state
            if (count > 0) begin
                count <= count - 1;
            end else begin
                state <= 2'b10; // transition to TERMINAL COUNT state
            end
        end
        2'b10: begin // TERMINAL COUNT state
            if (load) begin
                state <= 2'b00; // transition to LOAD state
            end
        end
    endcase
end

assign tc = (state == 2'b10);

initial begin
    state <= 2'b00; // initialize to LOAD state
end

endmodule