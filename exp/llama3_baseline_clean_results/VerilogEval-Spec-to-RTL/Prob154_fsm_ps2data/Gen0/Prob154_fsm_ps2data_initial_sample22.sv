module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // idle, byte1, byte2
reg [23:0] message; // 3-byte message
reg [7:0] byte1, byte2, byte3; // individual bytes

// state transitions
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // idle
        message <= 24'b0;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        case (state)
            2'b00: begin // idle
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // byte1
                    byte1 <= in;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin // byte1
                state <= 2'b10; // byte2
                byte2 <= in;
            end
            2'b10: begin // byte2
                state <= 2'b00; // idle
                byte3 <= in;
            end
            default: state <= 2'b00; // idle
        endcase
    end
end

// message construction
always @(posedge clk) begin
    if (reset) begin
        message <= 24'b0;
    end else if (state == 2'b10) begin // byte2
        message <= {byte1, byte2, in};
    end
end

// output logic
assign out_bytes = (done)? message : 24'b0;
assign done = (state == 2'b10)? 1'b1 : 1'b0;

endmodule