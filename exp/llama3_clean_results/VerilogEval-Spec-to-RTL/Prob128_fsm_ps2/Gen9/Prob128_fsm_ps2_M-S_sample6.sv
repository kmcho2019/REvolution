module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

logic [1:0] byte_count;
logic [7:0] prev_in;

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 2'b00;
        prev_in <= 8'b0;
    end
    else begin
        if (in !== prev_in) begin // New byte received
            prev_in <= in;
            case(byte_count)
                2'b00: begin // IDLE state
                    if(in[3]) byte_count <= 2'b01; // Transition to BYTE1 if in[3] = 1
                end
                2'b01, 2'b10: byte_count <= byte_count + 1'b1; // Increment byte_count for BYTE1 and BYTE2 states
            endcase
        end
    end
end

assign done = (byte_count == 2'b10) && (in !== prev_in);