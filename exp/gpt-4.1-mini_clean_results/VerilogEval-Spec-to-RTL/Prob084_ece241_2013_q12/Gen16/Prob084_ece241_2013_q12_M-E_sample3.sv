module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    wire [7:0] Q;
    wire shift_enable = enable;
    wire [2:0] sel = {A,B,C};

    // Generate 8 D flip-flops connected in series for the shift register
    // Q[0] takes input S, others take input from previous Q
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : shift_chain
            wire d_in;
            if (i == 0)
                assign d_in = S;
            else
                assign d_in = Q[i-1];
            DFF_en ff_inst (
                .clk(clk),
                .en(shift_enable),
                .d(d_in),
                .q(Q[i])
            );
        end
    endgenerate

    // One-hot multiplexer implemented by combining bits with mask
    assign Z = ((sel == 3'd0) ? Q[0] :
                (sel == 3'd1) ? Q[1] :
                (sel == 3'd2) ? Q[2] :
                (sel == 3'd3) ? Q[3] :
                (sel == 3'd4) ? Q[4] :
                (sel == 3'd5) ? Q[5] :
                (sel == 3'd6) ? Q[6] :
                               Q[7]);

endmodule


// D flip-flop with enable; on rising edge clk, if enable high, q <= d; else q <= q
module DFF_en (
    input clk,
    input en,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (en)
            q <= d;
    end
endmodule