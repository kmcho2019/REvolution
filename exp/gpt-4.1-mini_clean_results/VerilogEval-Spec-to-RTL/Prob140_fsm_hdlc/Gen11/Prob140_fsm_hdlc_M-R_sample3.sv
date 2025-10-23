module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] counter;

    // Next counter combinational logic as a wire
    wire [2:0] next_counter = (in) ? 
                                ((counter < 3'd7) ? (counter + 3'd1) : 3'd7) 
                              : 3'd0;

    // Outputs as wires, Moore outputs based on current counter and input
    wire disc_w = (counter == 3'd5) && (in == 1'b0);
    wire flag_w = (counter == 3'd6) && (in == 1'b0);
    wire err_w  = (next_counter == 3'd7);

    // Sequential process to register state and outputs on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
        end else begin
            counter <= next_counter;
            disc    <= disc_w;
            flag    <= flag_w;
            err     <= err_w;
        end
    end

endmodule