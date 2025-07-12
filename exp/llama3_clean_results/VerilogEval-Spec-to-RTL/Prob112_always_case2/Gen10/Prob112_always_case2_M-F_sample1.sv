module TopModule(
    input  [3:0] in,
    output logic [1:0] pos
);

always_comb begin
    if (in[3]) begin // Check MSB first
        pos = 2'b11;
    end else if (in[2]) begin // If MSB is not '1', check the next bit
        pos = 2'b10;
    end else if (in[1]) begin // Continue checking bits
        pos = 2'b01;
    end else if (in[0]) begin // Check the LSB
        pos = 2'b00;
    end else begin // If no '1' bits are found
        pos = 2'b00;
    end
end

endmodule