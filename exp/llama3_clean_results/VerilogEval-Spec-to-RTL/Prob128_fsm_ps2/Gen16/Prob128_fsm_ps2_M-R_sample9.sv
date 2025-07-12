module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
logic [1:0] state;
logic msg_received;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // SEARCH
        msg_received <= 0;
    end
    else begin
        case(state)
            2'b00: begin // SEARCH
                if(in[3]) begin
                    state <= 2'b01; // BYTE1
                end
            end
            2'b01: begin // BYTE1
                state <= 2'b10; // BYTE2
            end
            2'b10: begin // BYTE2
                state <= 2'b00; // SEARCH
                msg_received <= 1; // Set msg_received flag
            end
        endcase
    end
end

// Assert 'done' when a message is fully received
assign done = msg_received;

always_ff @(posedge clk) begin
    if(~reset && (state == 2'b00)) begin
        msg_received <= 0;
    end
end

endmodule