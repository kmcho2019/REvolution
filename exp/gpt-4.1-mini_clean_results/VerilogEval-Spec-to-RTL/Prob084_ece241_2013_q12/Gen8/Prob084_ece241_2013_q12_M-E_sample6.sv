module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] Q;
    wire [7:0] select_onehot;

    // Shift register with data shifted toward Q[7]
    // Q[7] <= Q[6], Q[6] <= Q[5], ..., Q[1] <= Q[0], Q[0] <= S
    always @(posedge clk) begin
        if (enable) begin
            Q[7] <= Q[6];
            Q[6] <= Q[5];
            Q[5] <= Q[4];
            Q[4] <= Q[3];
            Q[3] <= Q[2];
            Q[2] <= Q[1];
            Q[1] <= Q[0];
            Q[0] <= S;
        end
    end

    // Decode ABC into one-hot select signal
    assign select_onehot = 8'b00000001 << {A,B,C};

    // Multiplexer by AND-OR: select_onehot[i] & Q[i]
    wire [7:0] gated_bits;
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : mux_loop
            assign gated_bits[i] = select_onehot[i] & Q[i];
        end
    endgenerate

    // OR all gated bits to produce Z
    assign Z = |gated_bits;

endmodule