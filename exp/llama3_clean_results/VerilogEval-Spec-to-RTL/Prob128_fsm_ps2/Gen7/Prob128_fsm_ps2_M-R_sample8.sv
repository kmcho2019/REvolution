module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

// Define states for the FSM
reg [1:0] state;
reg [1:0] next_state;

// Shift register to store the last three bytes received
reg [23:0] byte_register;

// Counter to keep track of the number of bytes received
reg [1:0] byte_count;

assign done = (state == 2'b10 && byte_count == 2'b11);

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
        byte_register <= 0;
        byte_count <= 0;
    end
    else begin
        case(state)
            2'b00: begin
                if(in[3]) begin
                    state <= 2'b01;
                    byte_register <= {in, 16'd0};
                    byte_count <= 1;
                end
            end
            2'b01: begin
                byte_register <= {byte_register[15:0], in};
                byte_count <= byte_count + 1;
                if(byte_count == 2'b11) begin
                    state <= 2'b10;
                end
            end
            2'b10: begin
                state <= 2'b00;
                byte_register <= 0;
                byte_count <= 0;
            end
        endcase
    end
end

endmodule