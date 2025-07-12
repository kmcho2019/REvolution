module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, ignored
    output out
);

// Use a 3-bit vector as an address to a small ROM
// Address = {a,b,c}
// ROM content: indexed by abc in binary: {a,b,c}
// Let's create a table for out according to the Karnaugh map, disregarding d

// The Karnaugh map rearranged for inputs a,b,c with d don't-care:
// We consider all 8 possible combinations of a,b,c and choose out accordingly.

// Let's determine out for each abc combination:
// Since d is don't care, pick a value from the Karnaugh map for both d=0 and d=1 and ensure consistency.

// Recollect the Karnaugh map with a,b,c,d variables:
// The rows are cd, the columns are ab:

// Map indices:
// cd ab | 00 01 11 10
// 00    | d  0  1  1
// 01    | 0  0  d  d
// 11    | 0  1  1  1
// 10    | 0  1  1  1

// Since d is don't care, we can ignore its value and just select output to produce consistent truth table for a,b,c.

// We have inputs a,b,c, and want out = ROM[{a,b,c}]

// Generate truth table by choosing an arbitrary d (e.g., d=0) and reading the output:

// When d=0
// For each (a,b,c):

// c d=0 d=1 => ignoring d, using c=0/1 only (since d is don't-care)
// Let's fix d=0:

// Let's interpret map cell by cell:

// For c=0 d=0:
// ab=00: map value = d (don't care) => choose 0
// ab=01: map value = 0
// ab=10: map value = 1
// ab=11: map value = 1

// For c=1 d=0:
// ab=00: map value = 0
// ab=01: map value = 0
// ab=10: map value = d (don't care) => choose 0
// ab=11: map value = d (don't care) => choose 0

// Wait, the problem states rows as cd, columns as ab, which means c and d are rows, a and b are columns.

// We can map inputs to cd and ab as:

// cd = {c,d}
// ab = {a,b}

// So for each combination of inputs a,b,c,d, out is specified in the map.

// Since d is don't care, for each (a,b,c) we check the two possible values of d (0 or 1), if they agree, pick that, if not, pick arbitrary.

// Let's construct a truth table for (a,b,c) by choosing d=0 output:

// (a,b,c,d) -> out

// For (a,b,c,d=0):
// Row index = cd = c d
// Column index = ab = a b

// Let's iterate:

// c d=0 0
// a b=0 0 => row 00 col 00 => map: d => choose 0
// a b=0 1 => row 00 col 01 => map: 0
// a b=1 0 => row 00 col 10 => map:1
// a b=1 1 => row 00 col 11 => map:1

// c d=1 0
// a b=0 0 => row 10 col 00 => 0
// a b=0 1 => row 10 col 01 =>1
// a b=1 0 => row 10 col 10 =>1
// a b=1 1 => row 10 col 11 =>1

// Wait d=0 or d=1 is the second index of cd:

// Let's define cd values properly:

// 00 c=0 d=0
// 01 c=0 d=1
// 11 c=1 d=1
// 10 c=1 d=0

// So:

// For d=0:
// cd=00 when c=0 d=0
// cd=10 when c=1 d=0

// For d=1:
// cd=01 when c=0 d=1
// cd=11 when c=1 d=1

// Let's fill out for d=0 (d=0):

// When c=0 d=0 (cd=00), a,b=
// 01 (ab=01): map=0
// 00 (ab=00): d (choose 0)
// 10 (ab=10):1
// 11 (ab=11):1

// When c=1 d=0 (cd=10), a,b=
// 00:0
// 01:1
// 10:1
// 11:1

// Let's tabulate all 8 combinations of a,b,c with d=0:

// (a,b,c) out
// 0 0 0 => cd=00, ab=00 => 0
// 0 1 0 => cd=00, ab=01 => 0
// 1 0 0 => cd=00, ab=10 => 1
// 1 1 0 => cd=00, ab=11 => 1
// 0 0 1 => cd=10, ab=00 => 0
// 0 1 1 => cd=10, ab=01 => 1
// 1 0 1 => cd=10, ab=10 =>1
// 1 1 1 => cd=10, ab=11 =>1

// So the ROM content indexed by {a,b,c} (abc order) is:

// abc | out
// 000 | 0
// 001 | 0
// 010 | 0
// 011 | 1
// 100 | 0
// 101 | 1
// 110 | 1
// 111 | 1

// So address = {a,b,c} with a as MSB, c as LSB:

// 0: 000 -> 0
// 1: 001 -> 0
// 2: 010 -> 0
// 3: 011 -> 1
// 4: 100 -> 0
// 5: 101 -> 1
// 6: 110 -> 1
// 7: 111 -> 1

// Implement this as a case statement in combinational always block or as ROM array.

// We'll implement as combinational ROM indexed by abc.

reg [7:0] rom = 8'b000100111; // binary reversed? Actually assign properly.

initial begin
    // index: abc from 0 to 7, assign bits accordingly
    // bit 0: abc=000 => 0
    // bit 1: abc=001 => 0
    // bit 2: abc=010 => 0
    // bit 3: abc=011 => 1
    // bit 4: abc=100 => 0
    // bit 5: abc=101 => 1
    // bit 6: abc=110 => 1
    // bit 7: abc=111 => 1
end

wire [2:0] addr = {a,b,c};
assign out = rom[addr];

endmodule