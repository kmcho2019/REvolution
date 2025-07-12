module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // First level: Decode upper 4 bits to select 1 of 16 groups
    wire [15:0] group_en;
    wire [15:0] group_out;
    
    // 4-to-16 decoder for group selection
    decoder_4to16 upper_decoder (
        .in(sel[7:4]),
        .out(group_en)
    );
    
    // Second level: 16 groups of 16-input transmission-gate muxes
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : group_muxes
            // Only activate the selected group
            wire [15:0] local_in = in[(i*16)+15 : i*16];
            wire [3:0] local_sel = sel[3:0];
            wire local_out;
            
            // Transmission-gate based 16:1 mux
            tg_mux16 mux16 (
                .in(local_in),
                .sel(local_sel),
                .en(group_en[i]),
                .out(local_out)
            );
            
            assign group_out[i] = group_en[i] ? local_out : 1'bz;
        end
    endgenerate
    
    // Final output combines all group outputs
    assign out = |group_out;
    
endmodule

// Transmission-gate based 16:1 mux
module tg_mux16 (
    input  [15:0] in,
    input  [3:0]  sel,
    input         en,
    output        out
);
    wire [15:0] tg_out;
    
    // Transmission gate implementation
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : tg_array
            // Transmission gate controlled by decoded select
            wire tg_control = en & (sel == i);
            tranif1 tg (tg_out[i], in[i], tg_control);
        end
    endgenerate
    
    // Combine all transmission gate outputs
    assign out = |tg_out;
endmodule

// Active-high 4-to-16 decoder
module decoder_4to16 (
    input  [3:0] in,
    output [15:0] out
);
    assign out = (1 << in);
endmodule