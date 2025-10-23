module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // One-hot state encoding
    localparam [4:0] IDLE   = 5'b00001;
    localparam [4:0] GOT1   = 5'b00010;
    localparam [4:0] GOT11  = 5'b00100;
    localparam [4:0] GOT110 = 5'b01000;
    localparam [4:0] FOUND  = 5'b10000;

    reg [4:0] current_state;

    // State register (sequential logic)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic (combinational using assign)
    wire [4:0] next_state;
    assign next_state[0] = (~current_state[4] & ~current_state[3] & ~current_state[2] & ~current_state[1] & ~data) |  // Stay in IDLE if 0
                          (~current_state[4] & ~current_state[3] & current_state[2] & ~data) |  // GOT11->IDLE if 0
                          (~current_state[4] & current_state[3] & ~data);  // GOT110->IDLE if 0

    assign next_state[1] = (~current_state[4] & ~current_state[3] & ~current_state[2] & ~current_state[1] & data) |  // IDLE->GOT1 if 1
                          (~current_state[4] & ~current_state[3] & current_state[1] & ~data);  // GOT1->IDLE if 0

    assign next_state[2] = (~current_state[4] & ~current_state[3] & current_state[1] & data) |  // GOT1->GOT11 if 1
                          (~current_state[4] & ~current_state[3] & current_state[2] & data);  // GOT11->GOT11 if 1

    assign next_state[3] = (~current_state[4] & ~current_state[3] & current_state[2] & ~data);  // GOT11->GOT110 if 0

    assign next_state[4] = (~current_state[4] & current_state[3] & data) |  // GOT110->FOUND if 1
                          (current_state[4]);  // Stay in FOUND

    // Output logic
    assign start_shifting = current_state[4];

endmodule